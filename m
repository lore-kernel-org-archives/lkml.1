Return-Path: <linux-kernel-owner+w=401wt.eu-S1755234AbXEBPvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbXEBPvK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 11:51:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755242AbXEBPvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 11:51:09 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:50968 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755234AbXEBPvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 11:51:08 -0400
X-Sasl-enc: BdY0xKWZqiexYcN7frvH9tBhkmZFOewUc4QJrUV6sDKB 1178121066
Date: Wed, 2 May 2007 12:51:02 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][ 3/5] sched: implement staircase deadline cpu scheduler
Message-ID: <20070502155102.GB18127@khazad-dum.debian.net>
References: <200703271210.39429.kernel@kolivas.org> <20070430115014.0fff7772.akpm@linux-foundation.org> <200705022223.51809.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705022223.51809.kernel@kolivas.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 May 2007, Con Kolivas wrote:
> Anyway, good, bad or indifferent I intend to keep it around for comparison to 
> drive cfs further.

Well, just to let you know some of us really like the design, and prefer to
use SD and have an extremely strict scheduling priority set through nice
levels, so it is not there just to drive CFS further :-)   I imagine people
in the embedded world might want it for that reason, too.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
