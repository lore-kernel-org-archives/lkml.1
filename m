Return-Path: <linux-kernel-owner+w=401wt.eu-S1759014AbYFXLIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759014AbYFXLIQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 07:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbYFXLIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 07:08:00 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:46046 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642AbYFXLIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 07:08:00 -0400
Date: Tue, 24 Jun 2008 14:06:01 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Bernhard Walle <bwalle@suse.de>
Subject: Re: [patch 06/10] Add return value to reserve_bootmem_node()
Message-ID: <20080624110601.GA16021@cs181140183.pp.htv.fi>
References: <20080623225737.837265824@mini.kroah.org> <20080623230458.GF29853@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080623230458.GF29853@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

can you put this patch in front of patch 4
(x86: use BOOTMEM_EXCLUSIVE on 32-bit) in the
series file for working bisecting of 2.6.25.y ?

TIA
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

