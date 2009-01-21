Return-Path: <linux-kernel-owner+w=401wt.eu-S1755225AbZAUXs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbZAUXs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 18:48:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbZAUXsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 18:48:50 -0500
Received: from smtp.ultrahosting.com ([74.213.174.254]:33432 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602AbZAUXst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 18:48:49 -0500
Date: Wed, 21 Jan 2009 18:45:28 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Tejun Heo <tj@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, roel kluin <roel.kluin@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Brian Gerst <brgerst@gmail.com>,
       Eric Biederman <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>, travis@sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, steiner@sgi.com,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH core/percpu REPOST] linker script: add missing
 VMLINUX_SYMBOL
In-Reply-To: <49717AE6.9060207@kernel.org>
Message-ID: <alpine.DEB.1.10.0901211843140.1495@qirst.com>
References: <20090115122222.GI22850@elte.hu> <496F3577.4020303@kernel.org> <20090115133206.GA31416@elte.hu> <20090115133916.GA3417@elte.hu> <496FB09A.8020808@kernel.org> <496FE2B3.3060706@gmail.com> <496FFE45.1070802@gmail.com> <20090116131601.GA20593@elte.hu>
 <49708FEA.9000508@gmail.com> <20090116221651.GA32736@elte.hu> <20090116223828.GA9294@elte.hu> <49716F0E.7060605@gmail.com> <49716FBF.7080203@kernel.org> <49717AE6.9060207@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Yup we forgot that one.

Reviewed-by: Christoph Lameter <cl@linux-foundation.org>

(not sure about the exact tag to use. AFAICT I wrote some early version
of this code)


