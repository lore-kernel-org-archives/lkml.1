Return-Path: <linux-kernel-owner+w=401wt.eu-S1758142AbZKJUvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142AbZKJUvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 15:51:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758114AbZKJUvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 15:51:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59063 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751659AbZKJUvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 15:51:51 -0500
Date: Tue, 10 Nov 2009 12:51:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alex Chiang <achiang@hp.com>
Cc: David Rientjes <rientjes@google.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Gary Hade <garyhade@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Badari Pulavarty <pbadari@us.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch -mm] mm: slab allocate memory section nodemask for large
 systems
Message-Id: <20091110125131.30376c03.akpm@linux-foundation.org>
In-Reply-To: <20091102204726.GG5525@ldl.fc.hp.com>
References: <20091022040814.15705.95572.stgit@bob.kio>
	<20091022041510.15705.5410.stgit@bob.kio>
	<alpine.DEB.2.00.0910221249030.26631@chino.kir.corp.google.com>
	<20091027195907.GJ14102@ldl.fc.hp.com>
	<alpine.DEB.2.00.0910271422090.22335@chino.kir.corp.google.com>
	<20091028083137.GA24140@osiris.boeblingen.de.ibm.com>
	<alpine.DEB.2.00.0910280159380.7122@chino.kir.corp.google.com>
	<20091028183905.GF22743@ldl.fc.hp.com>
	<alpine.DEB.2.00.0910281315370.23279@chino.kir.corp.google.com>
	<20091102204726.GG5525@ldl.fc.hp.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Nov 2009 13:47:26 -0700
Alex Chiang <achiang@hp.com> wrote:

> I can respin this series once more, including David's Acked-by:
> and adding his patch if that makes life easier for you.

Yes, please redo and resend.

The prerequisite Documentation/ patches are a bit of a mess - some have
been cherrypicked into Greg's tree I believe and some haven't.  So
please also send out whatever is needed to bring linux-next up to date.


