Return-Path: <linux-kernel-owner+w=401wt.eu-S1758062AbXI2GXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062AbXI2GXl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 02:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756654AbXI2GXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 02:23:32 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33947 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755137AbXI2GXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 02:23:31 -0400
Message-ID: <46FDEF61.40002@garzik.org>
Date: Sat, 29 Sep 2007 02:23:29 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: correct kernel parameter in documentation.
References: <20070927155013.GA20219@redhat.com>
In-Reply-To: <20070927155013.GA20219@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> 'noacpi' isn't a standalone parameter, give it its prefix.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>

applied

(though in general we should not list module parameters here, I am OK 
with this one)


