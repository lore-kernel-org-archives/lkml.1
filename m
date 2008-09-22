Return-Path: <linux-kernel-owner+w=401wt.eu-S1754877AbYIVXrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbYIVXrM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 19:47:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753760AbYIVXq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 19:46:58 -0400
Received: from toccata.ens-lyon.org ([140.77.166.68]:35322 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676AbYIVXq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 19:46:58 -0400
Date: Tue, 23 Sep 2008 01:46:56 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] Only register notifiers when the braille console is used.
Message-ID: <20080922234656.GH4252@implementation>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, stable@kernel.org
References: <20080922214031.GJ5930@implementation> <20080922163621.a9f001ab.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080922163621.a9f001ab.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton, le Mon 22 Sep 2008 16:36:21 -0700, a écrit :
> On Mon, 22 Sep 2008 23:40:31 +0200
> Samuel Thibault <samuel.thibault@ens-lyon.org> wrote:
> > Only register the braille driver VT and keyboard notifiers when the
> > braille console is used.  Avoids eating insert or backspace keys.
> > 
> > http://bugzilla.kernel.org/show_bug.cgi?id=11242
> > 
> > Signed-off-by: Pascal Terjan <pterjan@mandriva.com>
> > Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
> 
> I have a suspision from your signoff trail that Pascal actually authored
> this patch.  Is that correct?

Err, yes.

> If so, the authorship should have been tracked by putting his From:
> line right at the top of the changelog.

Ah, sorry, I still haven't catched up with the new usages.

Samuel
