Return-Path: <linux-kernel-owner+w=401wt.eu-S1754536AbZKHTlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbZKHTlJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 14:41:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754030AbZKHTlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 14:41:08 -0500
Received: from one.firstfloor.org ([213.235.205.2]:53366 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbZKHTlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 14:41:08 -0500
Date: Sun, 8 Nov 2009 20:41:12 +0100
From: Andi Kleen <andi@firstfloor.org>
To: matthieu castet <castet.matthieu@free.fr>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, jkosina@suse.cz, hpa@zytor.com
Subject: Re: Using x86 segments against NULL pointer deference exploit
Message-ID: <20091108194112.GB14381@basil.fritz.box>
References: <1257512389.4af41dc504e1b@imp.free.fr> <87eiob76fh.fsf@basil.nowhere.org> <4AF6D7F8.3070004@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF6D7F8.3070004@free.fr>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please see 12.3.3.3 of 
http://www.intel.com/Assets/PDF/manual/248966.pdf
for details why this is a bad idea.

-Andi
