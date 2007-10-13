Return-Path: <linux-kernel-owner+w=401wt.eu-S1760202AbXJMIxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760202AbXJMIxN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 04:53:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbXJMIw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 04:52:58 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33236 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752533AbXJMIw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 04:52:57 -0400
Date: Sat, 13 Oct 2007 01:52:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: bbpetkov@yahoo.de
Cc: linux-kernel@vger.kernel.org, Eugene Teo <eugeneteo@kernel.sg>
Subject: Re: -mm merge plans for 2.6.24
Message-Id: <20071013015252.3f916ef1.akpm@linux-foundation.org>
In-Reply-To: <20071013084455.GA5656@gollum.tnic>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
	<20071013084455.GA5656@gollum.tnic>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Oct 2007 10:44:55 +0200 Borislav Petkov <bbpetkov@yahoo.de> wrote:

> can you please add http://lkml.org/lkml/2007/7/30/98 also to the misc-queue for
> the warning still persists and the patch is good to go as is (against current git
> v2.6.23-2840-g752097c, for example) albeit with a little fuzziness.

I got completely fed up with maintaining that patch against ongoing churn
frenzy in Greg's trees so I dropped it.

If/when things settle down in that area someone will need to redo the
patch.

