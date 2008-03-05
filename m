Return-Path: <linux-kernel-owner+w=401wt.eu-S1759827AbYCEVft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759827AbYCEVft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 16:35:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbYCEVfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 16:35:40 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:63362 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbYCEVfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 16:35:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JjSdUbelzxdg7NP1+hqZ60NubZudma/bgqtznIznNjJAzXkZUwYonpplwN9r0TXs601WYmCSemO9kwZTTpIIEOVTRwV/VY8Yxzl5eXjmQ3trAHcYxW9Bl92qcjIQFzHbb1Zgli+RMRW9Vdl0CWSFQF3OmxrtOBitGozG5mB2prk=
Message-ID: <4d8e3fd30803051335u29f9dc6am8198931b0d424e24@mail.gmail.com>
Date: Wed, 5 Mar 2008 22:35:37 +0100
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Roel Kluin" <12o3l@tiscali.nl>
Subject: Re: [PATCH] checkpatch: take 2 - Make some text more consinstent and informative
Cc: linux-kernel@vger.kernel.org, apw@shadowen.org
In-Reply-To: <47CF0F42.6070708@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47CF0C30.3060008@gmail.com> <47CF0F42.6070708@tiscali.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 5, 2008 at 10:23 PM, Roel Kluin <12o3l@tiscali.nl> wrote:
[...]
>  > -                        ERROR("no spaces around that '$op' $at\n" .
>  > $hereptr);
>  > +                        ERROR("space are not required around that '$op'
>
>  "spaces are" or "space is"

spaces.
v3 almost ready...

Thanks.

Ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
