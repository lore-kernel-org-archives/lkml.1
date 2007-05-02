Return-Path: <linux-kernel-owner+w=401wt.eu-S2993368AbXEBP3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993368AbXEBP3V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 11:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993369AbXEBP3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 11:29:21 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35749 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993368AbXEBP3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 11:29:20 -0400
Date: Wed, 2 May 2007 16:29:06 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: checkpatch, a patch checking script.
Message-ID: <20070502152906.GA29642@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	linux-kernel@vger.kernel.org
References: <20070423141123.GA21174@skybase> <20070423104534.51bac974.akpm@linux-foundation.org> <20070425112133.4ae86399.randy.dunlap@oracle.com> <20070425143011.57247c1d.akpm@linux-foundation.org> <20070425172447.1576c399.akpm@linux-foundation.org> <20070426003911.GA19383@redhat.com> <4630109F.6090002@oracle.com> <20070425200207.77a2721a.akpm@linux-foundation.org> <20070428030805.GA13331@redhat.com> <Pine.LNX.4.62.0705021626080.3706@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.62.0705021626080.3706@pademelon.sonytel.be>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 04:28:27PM +0200, Geert Uytterhoeven wrote:
>   - Check for GNU extension __FUNCTION__

__FUNCTION__ is prefered  over __func__
