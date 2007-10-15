Return-Path: <linux-kernel-owner+w=401wt.eu-S1758060AbXJOC7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060AbXJOC7i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 22:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754940AbXJOC7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 22:59:30 -0400
Received: from mx1.suse.de ([195.135.220.2]:57032 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754533AbXJOC73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 22:59:29 -0400
Date: Sun, 14 Oct 2007 19:59:08 -0700
From: Greg KH <gregkh@suse.de>
To: Alistair John Strachan <alistair@devzero.co.uk>
Cc: Stefan Heinrichsen <gelbemauer@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: Which companies are helping developing the kernel
Message-ID: <20071015025908.GA6223@suse.de>
References: <20071014220622.203990@gmx.net> <200710142328.46850.alistair@devzero.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710142328.46850.alistair@devzero.co.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, 2007 at 11:28:46PM +0100, Alistair John Strachan wrote:
> On Sunday 14 October 2007 23:06:22 Stefan Heinrichsen wrote:
> > Hello,
> >
> > I posted this question at comp.linux.misc and where told this would be a
> > better place therefore. I would like to do a internship in the field of the
> > Linux kernel.
> > Can someone tell me where to find a list of companies (don't matter in
> > which country) that employ kernel developers?
> 
> I think Greg wrote a paper on this subject, so I've added him to CC in case he 
> has the link handy.

Yeah, but my paper didn't really track companies very well.  The lwn.net
article is the best, and below is my version of who did things in
2.6.23.  Note, the lack of a company is not an indicator that they did
nothing, just that I could not easily determine someone worked for them.
I'll try to send out my "who are you working for" emails in a week or so
to see if I can further categorize the "unknowns".

thanks,

greg k-h
-------------------------

Processed 7075 csets from 992 developers
126 employers found

Top changeset contributors by employer
(Unknown)                 1116 (15.8%)
(None)                     843 (11.9%)
Red Hat                    827 (11.7%)
IBM                        557 (7.9%)
Linux Foundation           528 (7.5%)
Novell                     449 (6.3%)
Intel                      242 (3.4%)
Oracle                     158 (2.2%)
MIPS Technologies          143 (2.0%)
Nokia                      133 (1.9%)
NetApp                     119 (1.7%)
NTT                         99 (1.4%)
Astaro                      97 (1.4%)
MontaVista                  90 (1.3%)
(Consultant)                86 (1.2%)
SGI                         84 (1.2%)
Qumranet                    74 (1.0%)
QLogic                      70 (1.0%)
(Academia)                  70 (1.0%)
SWsoft                      64 (0.9%)
Analog Devices              61 (0.9%)
HP                          60 (0.8%)
Sony                        59 (0.8%)
rPath                       56 (0.8%)
XenSource                   53 (0.7%)
CERN                        49 (0.7%)
CC Computer Consultants     48 (0.7%)
Freescale                   47 (0.7%)
Fujitsu                     47 (0.7%)
Tripeaks                    46 (0.7%)
linutronix                  44 (0.6%)
Snapgear                    39 (0.6%)
Simtec                      34 (0.5%)
Atmel                       28 (0.4%)
Google                      28 (0.4%)
Cisco                       27 (0.4%)
Toshiba                     25 (0.4%)
Broadcom                    25 (0.4%)
SteelEye                    24 (0.3%)
Renesas Technology          23 (0.3%)
Mellanox                    21 (0.3%)
LSI Logic                   17 (0.2%)
Adaptec                     16 (0.2%)
Wipro                       15 (0.2%)
Marvell                     14 (0.2%)
Miracle Linux               14 (0.2%)
Solid Boot Ltd.             14 (0.2%)
AMD                         12 (0.2%)
Hitachi                     11 (0.2%)
ARM                         11 (0.2%)
Canonical                   10 (0.1%)
XIV Information Systems      9 (0.1%)
OpenedHand                   9 (0.1%)
Open Grid Computing          9 (0.1%)
Veritas                      8 (0.1%)
Secretlab                    7 (0.1%)
Neterion                     7 (0.1%)
Katalix Systems              7 (0.1%)
SANPeople                    7 (0.1%)
Digi International           7 (0.1%)
Znyx Networks                6 (0.1%)
Wind River                   6 (0.1%)
NEC                          6 (0.1%)
Wolfson Microelectronics     6 (0.1%)
SUNY Computer Science        6 (0.1%)
NetXen                       6 (0.1%)
NVidia                       6 (0.1%)
Myricom                      6 (0.1%)
Chelsio                      5 (0.1%)
Realtek                      5 (0.1%)
IPUnity-Glenayre             5 (0.1%)
Linux Networx                5 (0.1%)
Barco                        4 (0.1%)
SIOS Technology              4 (0.1%)
MIPS                         4 (0.1%)
University of Aberdeen       4 (0.1%)
PiKRON s.r.o                 4 (0.1%)
Pardus                       4 (0.1%)
Crash Barrier                4 (0.1%)
Tresys                       4 (0.1%)
ClusterFS                    4 (0.1%)
Macq Electronique            3 (0.0%)
OLPC                         3 (0.0%)
CompuLab                     3 (0.0%)
DENX Software Engineering    3 (0.0%)
Embedded Alley Solutions     3 (0.0%)
Twin Sun                     3 (0.0%)
Transmode Systems            3 (0.0%)
Cosmosbay~Vectis             3 (0.0%)
Pengutronix                  2 (0.0%)
Sierra Wireless              2 (0.0%)
Real-Time Remedies           2 (0.0%)
Bull                         2 (0.0%)
ScaleMP Inc.                 2 (0.0%)
Samsung                      2 (0.0%)
MicroGate Systems            2 (0.0%)
Atomide                      2 (0.0%)
US National Security Agency    2 (0.0%)
VMWare                       2 (0.0%)
Verismo                      2 (0.0%)
Akamai Technologies          2 (0.0%)
CE Linux Forum               2 (0.0%)
Siemens                      1 (0.0%)
ONELAN                       1 (0.0%)
Xorcom                       1 (0.0%)
EXOSEC                       1 (0.0%)
LWN.net                      1 (0.0%)
Texas Instruments            1 (0.0%)
Promise Technology           1 (0.0%)
VA Linux Systems Japan       1 (0.0%)
University of Sevilla        1 (0.0%)
Motorola                     1 (0.0%)
HES-SO Valais Wallis         1 (0.0%)
SYSGO                        1 (0.0%)
Via                          1 (0.0%)
Telecom-Service              1 (0.0%)
Hauppauge                    1 (0.0%)
DSA                          1 (0.0%)
Vivecode                     1 (0.0%)
Mandriva                     1 (0.0%)
ATRON electronic             1 (0.0%)
Cytronics & Melware          1 (0.0%)
M&N Solutions                1 (0.0%)
Rockwell                     1 (0.0%)
8D Technologies              1 (0.0%)
University of Cambridge      1 (0.0%)

