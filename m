Return-Path: <linux-kernel-owner+w=401wt.eu-S1763269AbXHXViy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763269AbXHXViy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 17:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbXHXViq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 17:38:46 -0400
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3268 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678AbXHXVip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 17:38:45 -0400
Date: Fri, 24 Aug 2007 23:38:26 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: Pierre Chifflier <p.chifflier@inl.fr>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, linux-kernel@vger.kernel.org
Subject: Re: intel_rng: FWH not detected (and no entropy)
Message-ID: <20070824213826.GG13237@vanheusden.com>
References: <20070823090414.GD22638@piche.inl.fr> <20070823125304.GA22901@khazad-dum.debian.net> <20070823144114.GE22638@piche.inl.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070823144114.GE22638@piche.inl.fr>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Sat Aug 25 22:53:49 CEST 2007
X-Message-Flag: Want to extend your PGP web-of-trust? Coordinate a
	key-signing at www.biglumber.com
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This leaves the main problem, which is the lack of entropy. Does anyone
> have an idea on how to solve this problem ?

If you have a spare audio-card lying around or maybe a tv-card/webcam or
so, give then:
http://www.vanheusden.com/aed/ (for audio)
http://www.vanheusden.com/ved/ (for video4linux)
a try.

And no, audio-entropyd won't fill up the entropy pool in a second, it
takes a while. And often video-entropyd bails out because of not enough
noise in the video-signal.


Folkert van Heusden

-- 
MultiTail er et flexible tool for å kontrolere Logfiles og commandoer.
Med filtrer, farger, sammenføringer, forskeliger ansikter etc.
http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
