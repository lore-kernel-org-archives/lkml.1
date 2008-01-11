Return-Path: <linux-kernel-owner+w=401wt.eu-S1763461AbYAKXSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763461AbYAKXSv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 18:18:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762159AbYAKXSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 18:18:43 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:60424 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762098AbYAKXSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 18:18:42 -0500
Subject: Re: [PATCH] serverworks: IRQ routing needs no _p
From: Zachary Amsden <zach@vmware.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, mingo@redhat.com
In-Reply-To: <20080111181434.3dec6206@lxorguk.ukuu.org.uk>
References: <20080111181434.3dec6206@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Fri, 11 Jan 2008 15:22:41 -0800
Message-Id: <1200093761.21817.32.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-01-11 at 18:14 +0000, Alan Cox wrote:
> I can find no reason for the _p on the serverworks IRQ routing logic, and
> a review of the documentation contains no indication that any such delay
> is needed so lets try this
> 

Looks good to me; unfortunately my Serverworks boxes got upgraded so I
can't test, but install base is really big.

Acked-by: Zachary Amsden <zach@vmware.com>

