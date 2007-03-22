Return-Path: <linux-kernel-owner+w=401wt.eu-S934104AbXCVQL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934104AbXCVQL7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 12:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934109AbXCVQKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 12:10:06 -0400
Received: from mail.station1.mxsweep.com ([212.147.136.149]:3091 "EHLO
	blue.mxsweep.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934104AbXCVQJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 12:09:52 -0400
Message-ID: <4602AA29.4020607@draigBrady.com>
Date: Thu, 22 Mar 2007 16:09:13 +0000
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Thunderbird 1.5.0.8 (X11/20061116)
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>
CC: Jens Axboe <jens.axboe@oracle.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Tomas M <tomas@slax.org>, linux-kernel@vger.kernel.org
Subject: Re: max_loop limit
References: <460236CE.1030303@slax.org> <20070322110058.GB23664@tatooine.rebelbase.local> <46026A92.4020106@slax.org> <20070322144210.73dfaf83.dada1@cosmosbay.com> <20070322134230.GP19922@kernel.dk> <20070322145245.a49fefeb.dada1@cosmosbay.com> <20070322135456.GS19922@kernel.dk> <20070322141146.GN2986@holomorphy.com>
In-Reply-To: <20070322141146.GN2986@holomorphy.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Mlf-Version: 5.0.2.8415
X-Mlf-UniqueId: o200703221609510094286
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
> Any chance we can get some kind of devices set up for partitions of
> loop devices if we're going to redo loopdev setup? That's been a thorn
> in my side for some time.

This script might be of use:
http://www.pixelbeat.org/scripts/lomount.sh

cheers,
Pádraig.
