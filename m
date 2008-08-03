Return-Path: <linux-kernel-owner+w=401wt.eu-S1756005AbYHCLf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbYHCLf2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 07:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753772AbYHCLfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 07:35:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50672 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755AbYHCLfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 07:35:19 -0400
Message-ID: <4895972F.5020008@zytor.com>
Date: Sun, 03 Aug 2008 04:31:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: sukadev@us.ibm.com
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@osdl.org>,
       serue@us.ibm.com, matthltc@us.ibm.com,
       Pavel Emelyanov <xemul@openvz.org>,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>
Subject: Re: Per-instance devpts
References: <20080412172933.GA19295@us.ibm.com> <1208027215.28187.17.camel@x61.ebiederm.org> <48935205.3090807@zytor.com> <20080803050800.GA4322@us.ibm.com>
In-Reply-To: <20080803050800.GA4322@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sukadev@us.ibm.com wrote:
> 
> IIRC, /dev/tty also needs a similar symlink.
> 

Why?  I do not believe that is correct.

	-hpa

