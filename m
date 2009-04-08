Return-Path: <linux-kernel-owner+w=401wt.eu-S933049AbZDHPQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933049AbZDHPQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 11:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbZDHPQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 11:16:17 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:36637 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751087AbZDHPQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 11:16:16 -0400
X-Sasl-enc: Hrcb1aKGTOeqOWj3Sj6wQfXC2HbB7hUjlau0dQvZn6y3 1239203774
Date: Wed, 8 Apr 2009 12:16:12 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Lee Revell <rlrevell@joe-job.com>, Ric Wheeler <ricwheeler@gmail.com>,
       Theodore Tso <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       device-mapper development <dm-devel@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ak@linux.intel.com, "MASON, CHRISTOPHER" <CHRIS.MASON@oracle.com>
Subject: Re: [dm-devel] Barriers still not passing on simple dm devices...
Message-ID: <20090408151612.GF7802@khazad-dum.debian.net>
References: <20090326084205.GG27476@kernel.dk> <Pine.LNX.4.64.0903302314500.6158@hs20-bc2-1.build.redhat.com> <20090331104933.GJ5178@kernel.dk> <Pine.LNX.4.64.0904021923040.19415@hs20-bc2-1.build.redhat.com> <20090403081131.GP5178@kernel.dk> <49D77AC3.3020207@redhat.com> <20090405012839.GF7553@mit.edu> <49D89C06.1060700@gmail.com> <75b66ecd0904051814n353bb69bp76a38e36cac4d3fe@mail.gmail.com> <Pine.LNX.4.64.0904080839200.28196@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0904080839200.28196@hs20-bc2-1.build.redhat.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Apr 2009, Mikulas Patocka wrote:
> I have seen an installation having generator backup, but with another 
> serious flaw --- if someone plugged a computer causing short-circuit, it 
> turned off the circuit breaker for the whole rack :)

You will be hard-pressed to find datacenters where the above is NOT true
:-)

Although, usually one has TWO independent power feeds per rack, so a short
is likely to bring down just half of it, and any equipment properly set up
with dual independent power feeds should survive...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
