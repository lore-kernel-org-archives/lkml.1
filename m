Return-Path: <linux-kernel-owner+w=401wt.eu-S1753839AbYAIOo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbYAIOo0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 09:44:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbYAIOoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 09:44:16 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45373 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092AbYAIOoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 09:44:15 -0500
Date: Wed, 9 Jan 2008 09:44:12 -0500
From: Rik van Riel <riel@redhat.com>
To: Al Boldi <a1426z@gawab.com>
Cc: "Valerie Henson" <val.henson@gmail.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFD] Incremental fsck
Message-ID: <20080109094412.73f3249c@cuia.boston.redhat.com>
In-Reply-To: <200801091452.14890.a1426z@gawab.com>
References: <200801090022.55589.a1426z@gawab.com>
	<200801090740.12989.a1426z@gawab.com>
	<70b6f0bf0801082345vf57951ey642e35c3d6e5194f@mail.gmail.com>
	<200801091452.14890.a1426z@gawab.com>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jan 2008 14:52:14 +0300
Al Boldi <a1426z@gawab.com> wrote:

> Ok, but let's look at this a bit more opportunistic / optimistic.

You can't play fast and loose with data integrity.

Besides, if we looked at things optimistically, we would conclude
that no fsck will be needed, ever :)
 
> > http://infohost.nmt.edu/~val/review/chunkfs.pdf

You will really want to read this paper, if you haven't already.

-- 
All Rights Reversed
