Return-Path: <linux-kernel-owner+w=401wt.eu-S1759358AbYDAUWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759358AbYDAUWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 16:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756961AbYDAUWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 16:22:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38709 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756907AbYDAUWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 16:22:25 -0400
Message-ID: <47F29972.2080504@zytor.com>
Date: Tue, 01 Apr 2008 13:22:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: David Newall <davidn@davidnewall.com>, "John T." <j.thomast@yahoo.com>,
       linux-kernel@vger.kernel.org
Subject: Re: UTF-8 and Alt key in the console
References: <205509.99433.qm@web45710.mail.sp1.yahoo.com> <alpine.LNX.1.00.0803231942380.3157@fbirervta.pbzchgretzou.qr> <47ED7EBD.8070009@zytor.com> <alpine.LNX.1.10.0803290055270.18418@fbirervta.pbzchgretzou.qr> <47ED8C13.5060509@zytor.com> <alpine.LNX.1.10.0803290143180.18418@fbirervta.pbzchgretzou.qr> <47EDE2A4.8080702@davidnewall.com> <47EE76BD.2000708@zytor.com> <alpine.LNX.1.10.0804012200340.6604@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LNX.1.10.0804012200340.6604@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> 
> There is no way to check whether you are in the escape code. And there
> is no way to find its end.

Right, and wrong, respectively.  Read the standard.

	-hpa
