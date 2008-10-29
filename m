Return-Path: <linux-kernel-owner+w=401wt.eu-S1755748AbYJ2XfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748AbYJ2XfE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 19:35:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754614AbYJ2Xeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 19:34:50 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52826 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbYJ2Xet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 19:34:49 -0400
Date: Wed, 29 Oct 2008 19:33:51 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       me@bobcopeland.com, mcgrof@gmail.com, mickflemm@gmail.com
Subject: Re: pull request: wireless-2.6 2008-10-29
Message-ID: <20081029233350.GE3485@tuxdriver.com>
References: <20081029231855.GD3485@tuxdriver.com> <20081029162324.28f5864d@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081029162324.28f5864d@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 04:23:24PM -0700, Arjan van de Ven wrote:
> On Wed, 29 Oct 2008 19:18:55 -0400
> "John W. Linville" <linville@tuxdriver.com> wrote:
> 
> > Dave,
> > 
> > Another quick round of fixes intended for 2.6.28...
> > 
> > This includes fixes for bugs 11749 and 11845, fixes a reset-related
> > regression in ath5k, fixes a Kconfig-related error for rt2x00, and
> > fixes some sparse warnings and a possible buffer overrun in libertas.
> > Also, it corrects a spelling error and marks Bob Copeland as an
> > ath5k maintainer.
> 
> speaking of ath5k:
> 
> http://www.kerneloops.org/version.php?start=1835008&end=1867775&version=28-rc
> 
> it seems to have added a few WARN_ON()s which now end up at the top of
> the list .. are these known or should I spend some time writing reports
> for netdev ?

I wasn't aware of them -- thanks... :-)

-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
