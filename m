Return-Path: <linux-kernel-owner+w=401wt.eu-S1755492AbZKEMRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbZKEMRf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 07:17:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754571AbZKEMRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 07:17:34 -0500
Received: from ozlabs.org ([203.10.76.45]:55175 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084AbZKEMRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 07:17:34 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 0/10] module: Speed up symbol resolution during module loading (using binary search)
Date: Thu, 5 Nov 2009 22:47:37 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>, linux-kbuild@vger.kernel.org,
       carmelo73@gmail.com, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
References: <9b2b86520911020852q49c55695rb05d87090fa9ad33@mail.gmail.com> <1257242782-10496-1-git-send-email-alan-jenkins@tuffmail.co.uk> <20091103155824.GA23857@kroah.com>
In-Reply-To: <20091103155824.GA23857@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911052247.37545.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Nov 2009 02:28:24 am Greg KH wrote:
> Can you send this to Ingo for inclusion in the -tip tree?  Or should it
> go through someone else's tree instead?

Gee, did the "module" prefix not supply sufficient hint? :)

I'd like an ack for the build and arm bits, but I'm not going to hold it
up if not.

Cheers,
Rusty.
