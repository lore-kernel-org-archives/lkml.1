Return-Path: <linux-kernel-owner+w=401wt.eu-S1753887AbYH0GXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbYH0GXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 02:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbYH0GXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 02:23:16 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:38772 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbYH0GXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 02:23:16 -0400
From: Marcel Janssen <korgull@home.nl>
Reply-To: korgull@home.nl
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] USB: add USB test and measurement class driver
Date: Wed, 27 Aug 2008 08:22:58 +0200
User-Agent: KMail/1.9.9
Cc: linux-usb@vger.kernel.org, Stefan Kopp <stefan_kopp@agilent.com>,
       Felipe Balbi <me@felipebalbi.com>, linux-kernel@vger.kernel.org,
       Marcel Janssen <marcel.janssen@admesy.nl>
References: <20080827000501.GA29570@kroah.com>
In-Reply-To: <20080827000501.GA29570@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808270822.59859.korgull@home.nl>
X-Spam-Score: -0.5 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,

On Wednesday 27 August 2008 02:05:01 Greg KH wrote:
> The autosuspend support isn't that hard either, but I would like to find
> someone with one of these devices to help me in testing that before I
> add it, so I imagine the driver can go into the tree without that being
> added at this time.

I think I can be of some help here. We have usbtmc devices that have this 
functionality included. The only difficulty I currently have is time. I'll be 
on a business trip for the next 3 weeks but have our units with me and may be 
able to test it.

Best regards,
Marcel Janssen


