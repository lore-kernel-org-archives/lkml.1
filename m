Return-Path: <linux-kernel-owner+w=401wt.eu-S1753414Ab0AITiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab0AITiS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 14:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098Ab0AITiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 14:38:17 -0500
Received: from solo.fdn.fr ([80.67.169.19]:56101 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285Ab0AITiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 14:38:17 -0500
X-Greylist: delayed 1668 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Jan 2010 14:38:16 EST
Date: Sat, 9 Jan 2010 20:10:25 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: "Paul G. Allen" <pgallen@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux Serial Performance
Message-ID: <20100109191025.GK4757@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	"Paul G. Allen" <pgallen@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <bd8e30a41001091057t97f90abgffe9cca329ace477@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bd8e30a41001091057t97f90abgffe9cca329ace477@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul G. Allen, le Sat 09 Jan 2010 10:57:48 -0800, a écrit :
> In all cases, the profiler shows the serial Tx
> to be about 20x faster (twenty times) on Windows XP than in Linux.

Did you properly set the serial port speed?

Samuel
