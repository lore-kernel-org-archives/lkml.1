Return-Path: <linux-kernel-owner+w=401wt.eu-S1761032AbZDGVRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761032AbZDGVRP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 17:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755795AbZDGVQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 17:16:58 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:34794 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810AbZDGVQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 17:16:58 -0400
Date: Tue, 7 Apr 2009 17:11:26 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH] [5/16] POISON: Add support for poison swap entries
In-Reply-To: <20090407151002.0AA8F1D046E@basil.firstfloor.org>
Message-ID: <alpine.DEB.1.10.0904071710500.12192@qirst.com>
References: <20090407509.382219156@firstfloor.org> <20090407151002.0AA8F1D046E@basil.firstfloor.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Could you separate the semantic changes to flag checking for migration
out for easier review?


