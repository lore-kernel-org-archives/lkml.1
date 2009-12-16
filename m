Return-Path: <linux-kernel-owner+w=401wt.eu-S1761581AbZLPFzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761581AbZLPFzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 00:55:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760766AbZLPFzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 00:55:49 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:40676 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760710AbZLPFzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 00:55:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=O0YGs3hq8/r38/gkxx09Dle1yFH/h61cchh5U/ug7wME5j1WfCQSxlTbetrVB296/I
         BXjrl0NLNvDeFLCFxVIVNgwd2V862mcXOzlK5VxmQ0FqSnkOgeT+yuf4DFlRz87Hy3PL
         lQ6OXxDHIc+IURrind+8qd9wrpcr8vj6u6BSk=
MIME-Version: 1.0
In-Reply-To: <4B2870A4.2020202@gmail.com>
References: <dd18b0c30912151454l1aa7fb97g951483993ab42502@mail.gmail.com> 
	<586c2acd0912151502o303f6b14g7277289ff5dc69b3@mail.gmail.com> 
	<586c2acd0912151508q5361d6a5o12016648935b4eec@mail.gmail.com> 
	<4B2870A4.2020202@gmail.com>
From: Younes Manton <younes.m@gmail.com>
Date: Wed, 16 Dec 2009 00:55:27 -0500
Message-ID: <586c2acd0912152155w4b19c1d2k5fe7f590060a4b48@mail.gmail.com>
Subject: Re: [drm] nouveau iMac crashes and burns
To: "Justin P. mattock" <justinmattock@gmail.com>
Cc: xorg@freedesktop.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 12:31 AM, Justin P. mattock
<justinmattock@gmail.com> wrote:
> hm.. any ideas i.g.
> it seems renouveau requirements
> needs at max 256 mb for memory
> on the card(and 2.4 kernel),
>
> looking at mmiotrace(seems the best way)
> I've turned on the tracer, but as soon
> as I load the module nouvaeu the system freezes!
>
> Justin P. Mattock
>

The page you found is for capturing the firmware as Nvidia's driver
uploads it to the card. We already have your firmware so you don't
need to do that. Apparently this is one of the integrated chips we
haven't got working yet so you'll just have to sit tight until someone
gets their hands on it.
