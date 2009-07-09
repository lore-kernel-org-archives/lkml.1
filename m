Return-Path: <linux-kernel-owner+w=401wt.eu-S1761564AbZGIPBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761564AbZGIPBF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 11:01:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761555AbZGIPAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 11:00:54 -0400
Received: from solo.fdn.fr ([80.67.169.19]:48488 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761171AbZGIPAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 11:00:53 -0400
Date: Thu, 9 Jul 2009 17:00:47 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       xorg@lists.freedesktop.org
Subject: Re: SIGQUIT from tty layer
Message-ID: <20090709150047.GE5328@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	xorg@lists.freedesktop.org
References: <20090709143141.GA17551@ben-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090709143141.GA17551@ben-laptop>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SIGQUIT is sent to the X server if the controling tty of the X server
(probably its VT) receives the QUIT character (usually control-\, i.e.
0x1c)

Samuel
