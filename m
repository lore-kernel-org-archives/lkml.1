Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbZETIoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbZETIoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 04:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754444AbZETIo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 04:44:27 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:48447 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072AbZETIo0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 04:44:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=ZnBvkmOtqlnm+ZyQbLT0/Xc/3FzbCmAi2U4RwAHVA8IMUB9l8TB/n6TwZPnvhp9Uyr
         cjcWEHUcK2EjB/OG91cfA45zbJkqMfTlsY2isBj1s6QCkgY6YWsddDPjyw9LDz8KzlKa
         umutRv7PhVzlwb4iQMFB5+aa5cS0E9zX2c8Tk=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Subject: Re: [PATCH] input: mt: Augment the event semantics documentation
Date: Wed, 20 May 2009 01:44:21 -0700
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc4; KDE/4.2.3; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <1242593479-9238-1-git-send-email-rydberg@euromail.se> <20090520025957.GE17649@dtor-d630.eng.vmware.com> <4A13BC50.4010705@euromail.se>
In-Reply-To: <4A13BC50.4010705@euromail.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905200144.22454.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 May 2009 01:16:16 Henrik Rydberg wrote:
> Dmitry Torokhov wrote:
> > Hi Henrik,
> >
> > On Sun, May 17, 2009 at 10:51:19PM +0200, Henrik Rydberg wrote:
> >> Through the collaboration to adapt the N-trig and Stantum HID
> >> drivers to the MT protocol, some semantic clarifications to the
> >> protocol have been made. This patch adds them to the MT documentation.
> >>
> >> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> >> Tested-by: Stéphane Chatty <chatty@enac.fr>
> >
> > I was wondering if the following changes would not make the text a bit
> > better:
>
> They do, thanks. I got more comments on the text, perhaps it is easiest
> if I send an additional patch on top of this one, with your changes
> included? It seems folding a patch is easier than to find out what
> changes were made to the changes.
>

Sure, send it along.

-- 
Dmitry
