Return-Path: <linux-kernel-owner+w=401wt.eu-S1754444AbYFWFDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbYFWFDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 01:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751166AbYFWFDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 01:03:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43924 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbYFWFDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 01:03:05 -0400
Date: Sun, 22 Jun 2008 22:01:18 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] Position Statement on Linux Kernel Modules
Message-ID: <20080623050118.GA22852@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As part of the Linux Foundation Technical board, we confront the issue
of closed source Linux kernel modules all the time, and we wanted to do
something that could be seen as a general "public statement" about them
that is easy to understand and point to when people have questions.

So, after working on this for a while, and asking some of the other
major contributors and maintainers of the kernel, what we have is below.

There is also a site at:
	http://www.linuxfoundation.org/en/Device_driver_statement
that contains a link to a statement from the Linux Foundation about this
topic, as well as some more descriptions and background information, and
a copy of the full statement as well.

I've also put a pretty pdf version at:
	http://www.kernel.org/pub/linux/kernel/people/gregkh/lkm_position_statement/lkm_pos_statement.pdf
in case people want to print it out :)

If there are any kernel developers who want to add their names to this
statement, please let me know by private email and I will be glad to add
it.

thanks,

greg k-h

------------------------------

Position Statement on Linux Kernel Modules
June 2008

We, the undersigned Linux kernel developers, consider any closed-source
Linux kernel module or driver to be harmful and undesirable.  We have
repeatedly found them to be detrimental to Linux users, businesses, and
the greater Linux ecosystem.  Such modules negate the openness,
stability, flexibility, and maintainability of the Linux development
model and shut their users off from the expertise of the Linux
community.  Vendors that provide closed-source kernel modules force
their customers to give up key Linux advantages or choose new vendors.
Therefore, in order to take full advantage of the cost savings and
shared support benefits open source has to offer, we urge vendors to
adopt a policy of supporting their customers on Linux with open-source
kernel code.

We speak only for ourselves, and not for any company we might work for
today, have in the past, or will in the future.

	Dave Airlie
	Jens Axboe
	Ralf Baechle
	Arnd Bergmann
	Vitaly Bordug
	James Bottomley
	Josh Boyer
	Neil Brown
	Mark Brown
	David Brownell
	Michael Buesch
	Franck Bui-Huu
	Adrian Bunk
	Ralph Campbell
	Mauro Carvalho Chehab
	Denis Cheng
	Jonathan Corbet
	Glauber Costa
	Alan Cox
	Magnus Damm
	Ahmed S. Darwish
	Robert P. J. Day
	Helge Deller
	Jean Delvare
	Mathieu Desnoyers
	Alexey Dobriyan
	Daniel Drake
	Alex Dubov
	Randy Dunlap
	Michael Ellerman
	Jan Engelhardt
	Mark Fasheh
	J. Bruce Fields
	Larry Finger
	Jeremy Fitzhardinge
	Mike Frysinger
	Kumar Gala
	Robin Getz
	Liam Girdwood
	Thomas Gleixner
	Brice Goglin
	Cyrill Gorcunov
	Andy Gospodarek
	Thomas Graf
	Harvey Harrison
	Stephen Hemminger
	Michael Hennerich
	Tejun Heo
	Benjamin Herrenschmidt
	Kristian Høgsberg
	Henrique de Moraes Holschuh
	Marcel Holtmann
	Mike Isely
	Takashi Iwai
	Olof Johansson
	Dave Jones
	Jesper Juhl
	Matthias Kaehlcke
	Kenji Kaneshige
	Jan Kara
	Jeremy Kerr
	Russell King
	Olaf Kirch
	Roel Kluin
	Hans-JÃŒrgen Koch
	Auke Kok
	Jiri Kosina
	Mariusz Kozlowski
	Greg Kroah-Hartman
	Michael Krufky
	Aneesh Kumar
	Clemens Ladisch
	Christoph Lameter
	Grant Likely
	John W. Linville
	Yinghai Lu
	Tony Luck
	Pavel Machek
	Matt Mackall
	Roland McGrath
	Patrick McHardy
	Kyle McMartin
	Paul Menage
	Thierry Merle
	Eric Miao
	Akinobu Mita
	Ingo Molnar
	Andrew Morton
	Paul Mundt
	Oleg Nesterov
	Luca Olivetti
	Pierre Ossman
	Venkatesh Pallipadi
	Nick Piggin
	Nicolas Pitre
	Richard Purdie
	Mike Rapoport
	Sam Ravnborg
	Gerrit Renker
	Stefan Richter
	David Rientjes
	Stefan Roese
	Francois Romieu
	Stephen Rothwell
	Maciej W. Rozycki
	Mark Salyzyn
	Yoshinori Sato
	Holger Schurig
	Yoshihiro Shimoda
	Sergei Shtylyov
	Kay Sievers
	Alexey Starikovskiy
	Alan Stern
	Hirokazu Takata
	Eliezer Tamir
	Doug Thompson
	FUJITA Tomonori
	Dmitry Torokhov
	Marcelo Tosatti
	Steven Toth
	Theodore Tso
	Geert Uytterhoeven
	Arjan van de Ven
	Ivo van Doorn
	Wim Van Sebroeck
	Hans Verkuil
	Anton Vorontsov
	Daniel Walker
	Dan J. Williams
	Darrick J. Wong
	David Woodhouse
	Chris Wright
	Bryan Wu
	Rafael J. Wysocki
	Herbert Xu
	Vlad Yasevich
	Peter Zijlstra
	Bartlomiej Zolnierkiewicz

