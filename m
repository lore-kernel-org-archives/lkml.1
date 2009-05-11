Return-Path: <linux-kernel-owner+w=401wt.eu-S1757056AbZEKBKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056AbZEKBKE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 21:10:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756342AbZEKBJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 21:09:53 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:48059 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552AbZEKBJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 21:09:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:mime-version:content-disposition
         :in-reply-to:x-mutt-references:x-mutt-fcc:x-length:x-uid:date
         :message-id:content-type:content-transfer-encoding;
        b=KOACqx/SRgheenWXEgm8H2TwB+Elbs0jVZgVsOahV9JpaG/HKvwFUypEwSRAJ5G7K3
         W99oopa0z+R2MUQLrSBWLwnYAUfGdHC0Eq8uJ5tqy9/Uytul01MRlKgx/fQkHrgIfojq
         y6fioUPtSbe0hCUae4R2eBnKib9r244FzRKiI=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, gregkh@suse.de,
       linux-input@vger.kernel.org, kay.sievers@vrfy.org
Subject: Re: [PATCH 0/4] fix some improper uses of dev_set_name
References: <1240273036-5995-1-git-send-email-cascardo@holoscopio.com> <20090422054531.GD9009@kroah.com> <20090422210610.GL4691@vespa.holoscopio.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090422210610.GL4691@vespa.holoscopio.com>
X-Mutt-References: <20090422210610.GL4691@vespa.holoscopio.com>
X-Mutt-Fcc: =sent-mail
X-Length: 1043
Date: Sun, 10 May 2009 18:09:40 -0700
Message-Id: <200905101809.41024.dmitry.torokhov@gmail.com>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 06:06:11PM -0300, Thadeu Lima de Souza Cascardo wrote:
> 
> Since I am not sure what the position/decision is about each one, I
> would like some input while I work into splitting them into subsystems.
> 

I applied the patch concerning input drivers into my 'next' branch,
thank you.

-- 
Dmitry
