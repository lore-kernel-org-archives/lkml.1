Return-Path: <linux-kernel-owner+w=401wt.eu-S932697AbZDARtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697AbZDARtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 13:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755086AbZDARtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 13:49:15 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:17377 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbZDARtO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 13:49:14 -0400
Date: Wed, 1 Apr 2009 18:50:40 +0200
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: spock@gentoo.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
       Ville =?ISO-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH] fbdev: fix color component field length documentation
Message-Id: <20090401185040.6b77143b.krzysztof.h1@poczta.fm>
In-Reply-To: <20090331222835.GA8482@tria>
References: <20090330220007.GC6540@spock.one.pl>
	<10f740e80903310018v7e12de88m696f07e40dc617e3@mail.gmail.com>
	<20090331222835.GA8482@tria>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-EMID: 8ce2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Apr 2009 00:28:35 +0200
Michal Januszewski <spock@gentoo.org> wrote:

> The documentation about the meaning of the color component bitfield lengths
> in pseudocolor modes is inconsistent.  Fix it, so that it indicates the
> correct interpretation everywhere, i.e. that 1 << length is the number
> of palette entries.
> 
> Signed-off-by: Michal Januszewski <spock@gentoo.org>
> Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
> Cc: Ville Syrjälä <syrjala@sci.fi>
> Cc: Geert Uytterhoeven <geert.uytterhoeven@gmail.com>
> ---
> This version of the patch incorporates Geert's comments about the
> meaning of the offset field for pseudocolor modes.
> 

Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>



----------------------------------------------------------------------
Twoj znajomy na stronie glownej portalu? Wkrec go! ;) 
Sprawdz >>> http://link.interia.pl/f20f2

