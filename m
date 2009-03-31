Return-Path: <linux-kernel-owner+w=401wt.eu-S1759424AbZCaNrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759424AbZCaNrn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 09:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756545AbZCaNrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 09:47:32 -0400
Received: from smtp19.orange.fr ([80.12.242.17]:58273 "EHLO smtp19.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755791AbZCaNrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 09:47:31 -0400
X-ME-UUID: 20090331134728345.5462E20000A5@mwinf1914.orange.fr
Subject: Re: Replacing VFAT as filesystem on removeable media
From: Xavier Bestel <xavier.bestel@free.fr>
To: Mark Williamson <mark.williamson@cl.cam.ac.uk>
Cc: Martin Steigerwald <Martin@lichtvoll.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, info@fsf.org, office@fsfeurope.org,
       info@linuxfoundation.org
In-Reply-To: <200903311357.44075.mark.williamson@cl.cam.ac.uk>
References: <200903311015.29222.Martin@Lichtvoll.de>
	 <200903311357.44075.mark.williamson@cl.cam.ac.uk>
Content-Type: text/plain
Date: Tue, 31 Mar 2009 15:47:07 +0200
Message-Id: <1238507227.27596.559.camel@skunk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-31 at 13:57 +0100, Mark Williamson wrote:
> Another approach which occurs to me would be to come up with a "filesystem over 
> USB" protocol so that the actual on-disk format is no longer relevant.

Look for MTP. It's what you want, made by Microsoft, and enables all
sorts of DRM niceties.

	Xav


