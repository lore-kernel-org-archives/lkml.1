Return-Path: <linux-kernel-owner+w=401wt.eu-S1755103AbZCGOsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103AbZCGOsX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 09:48:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbZCGOsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 09:48:10 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:38965 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbZCGOsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 09:48:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kqkiOqPVtbJSCy2c6MCeH0t76dp1ViQYWkwbjLUvLZsWFXBfn0xeqmTtsYLnFbAKaT
         iVjkpMLEfBlR/N7DKsnrEbihGb4lTv0M93BHtMMGcNtlvStYW6bk5jRU9giBVsvJgnvQ
         lhg3BUHAwUWhtwVPn5KiiXz/Sh98l3YyE26DM=
MIME-Version: 1.0
In-Reply-To: <20090306200515.GA26365@electric-eye.fr.zoreil.com>
References: <9e246b4d0903061127q7c82103dq88c5184765f3c17a@mail.gmail.com>
	 <9e246b4d0903061129g7b66dc3bm8013b75be671ca33@mail.gmail.com>
	 <20090306200515.GA26365@electric-eye.fr.zoreil.com>
Date: Sat, 7 Mar 2009 09:48:05 -0500
Message-ID: <9e246b4d0903070648k75d1c11ek5a36ac1dd905cd0@mail.gmail.com>
Subject: Re: r8169 MAC problem
From: Tim Durack <tdurack@gmail.com>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Ivan Vecera <ivecera@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 6, 2009 at 3:05 PM, Francois Romieu <romieu@fr.zoreil.com> wrote:
> Please Cc: Ivan.
>
> Tim Durack <tdurack@gmail.com> :
> [...]
>> Any ideas?
>
> Damn me, I should have noticed that the delay was below spec :o(
>
> Can you try the patch below on top of the current git kernel ?

Patch didn't apply cleanly, so I did it by hand.

My kernel patch/compile skills are a little rusty, so I'm still in the
process of testing...

Tim:>
