Return-Path: <linux-kernel-owner+w=401wt.eu-S1755391AbZGMLNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbZGMLNR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 07:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755267AbZGMLNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 07:13:16 -0400
Received: from kazi.fit.vutbr.cz ([147.229.8.12]:63143 "EHLO kazi.fit.vutbr.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755246AbZGMLNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 07:13:15 -0400
Date: Mon, 13 Jul 2009 13:12:15 +0200
From: Kasparek Tomas <kasparek@fit.vutbr.cz>
To: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: NFS client packet storm on 2.6.27.x
Message-ID: <20090713111214.GC30754@fit.vutbr.cz>
References: <20090113152201.GD47559@fit.vutbr.cz> <20090116104802.GF47559@fit.vutbr.cz> <20090118130835.GH47559@fit.vutbr.cz> <20090120150301.GG47559@fit.vutbr.cz> <1232465547.7055.3.camel@heimdal.trondhjem.org> <20090303120848.GV89843@fit.vutbr.cz> <1236089767.9631.4.camel@heimdal.trondhjem.org> <20090418051739.GL64731@fit.vutbr.cz> <20090422172707.GC57877@fit.vutbr.cz> <20090625055532.GC50277@fit.vutbr.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090625055532.GC50277@fit.vutbr.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 07:55:32AM +0200, Kasparek Tomas wrote:
> http://www.linux-nfs.org/Linux-2.6.x/2.6.27/
> 
> .../fixups_4/linux-2.6.27-001-respond_promptly_to_socket_errors.dif
> .../fixups_4/linux-2.6.27-002-respond_promptly_to_socket_errors_2.dif
> 
> ...
> Together with tcp_linger patch it seems to improve the situation a lot to
> state when it is possible for me to use 2.6.27.x kernels.
> 
> Trond, will it be possible to get tcp_linger and the upper twho patches to
> 2.6.27.x stable queue so others get these fixes?

I got no response so far, is there someone who could advise me what to do
to get above patches to 2.6.27.x stable? Or is there some reason, why this
is not possible at all?

Thanks for advice and/or suggestions.

--   

  Tomas Kasparek, PhD student  E-mail: kasparek@fit.vutbr.cz
  CVT FIT VUT Brno, L127       Web:    http://www.fit.vutbr.cz/~kasparek
  Bozetechova 1, 612 66        Fax:    +420 54114-1270
  Brno, Czech Republic         Phone:  +420 54114-1220

  jabber: tomas.kasparek@jabber.cz
  GPG: 2F1E 1AAF FD3B CFA3 1537  63BD DCBE 18FF A035 53BC

