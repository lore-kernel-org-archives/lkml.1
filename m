Return-Path: <linux-kernel-owner+w=401wt.eu-S1753249AbYACPLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbYACPLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 10:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600AbYACPLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 10:11:11 -0500
Received: from azur.resot.net ([217.175.160.20]:34829 "EHLO azur.ool.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622AbYACPLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 10:11:09 -0500
From: "werner" <werner@copaya.yi.org>
Subject: regression w.r.t. problems #lilo when an usb-key is present: problem no longer
To: linux-kernel@vger.kernel.org
X-Originating-IP: 192.168.1.1
X-Mailer: Usermin 1.320
Message-Id: <1199373011.32361@copaya.yi.org>
Date: Thu, 03 Jan 2008 12:10:12 -0300 (GFT)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bound1199373012"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--bound1199373012
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

I reported a regression, that when a usb-key is connected, #lilo produces a bootloader which don't work, on 2.6.24-rc6-git2, diferently to kernels before.
Yesterday I compiled 2.6.24-rc6-git8 with exactly the same kernel parameters, with this, the problem didnt occure again, on the same 2 computers.  Thus probably the problem was resolved
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
*** www.copaya.yi.org / www.monkey.is-a-geek.net ***
O =FAnico servidor comunit=E1rio na Guiana-Francesa.  Situado no local, r=E1pido, imuno contra guerras / desastres na Europa.   Servi=E7o n=E3o-comercial e gratuito de:  http (forum, p=E1gina web), irc (chat), ftp (download), name (subdomain) .

--bound1199373012--

