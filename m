Return-Path: <linux-kernel-owner+w=401wt.eu-S1753421AbZEZHvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbZEZHvE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 03:51:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbZEZHuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 03:50:55 -0400
Received: from aun.it.uu.se ([130.238.12.36]:60944 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626AbZEZHuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 03:50:54 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18971.40255.831510.595635@pilspetsen.it.uu.se>
Date: Tue, 26 May 2009 09:41:51 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: debian developer <debiandev@gmail.com>
Cc: GeunSik Lim <leemgs1@gmail.com>, linux kernel <kernelnewbies@nl.linux.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Unable to compile 2.6.30-rc7 on RHEL 4 - GCC 3.4.6
In-Reply-To: <f24d23310905252256h74d609d9l7e23b1cdc0a240c6@mail.gmail.com>
References: <f24d23310905250956u231fcd90u54d75894b9b91b9a@mail.gmail.com>
	<49b7c2350905251445n14397b82yc993f1a86d715d4d@mail.gmail.com>
	<f24d23310905252256h74d609d9l7e23b1cdc0a240c6@mail.gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

debian developer writes:
 > On Tue, May 26, 2009 at 3:15 AM, GeunSik Lim <leemgs1@gmail.com> wrote:
 > > Hi,
 > >
 > > If you keep gcc 3.X.X to compile recent kernel source contiunally,
 > > You will meet another problems again.
 > >
 > 
 > OK, so 3.x.x is officially not supposed to be used for compilation?

False, we support down to gcc-3.2.x.
