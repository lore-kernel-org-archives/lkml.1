Return-Path: <linux-kernel-owner+w=401wt.eu-S1760653AbYC0Sq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760653AbYC0Sq1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 14:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755418AbYC0SqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 14:46:17 -0400
Received: from relay1.sgi.com ([192.48.171.29]:37066 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755365AbYC0SqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 14:46:16 -0400
Date: Thu, 27 Mar 2008 11:44:14 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Thomas Gleixner <tglx@linutronix.de>, "Luck, Tony" <tony.luck@intel.com>,
       linux-arch@vger.kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: What if a TLB flush needed to sleep?
In-Reply-To: <1206624052.8514.570.camel@twins>
Message-ID: <Pine.LNX.4.64.0803271143540.7531@schroedinger.engr.sgi.com>
References: <1FE6DD409037234FAB833C420AA843ECE9DF60@orsmsx424.amr.corp.intel.com>
  <Pine.LNX.4.64.0803261222090.31000@schroedinger.engr.sgi.com> 
 <alpine.LFD.1.00.0803262121440.3781@apollo.tec.linutronix.de> 
 <Pine.LNX.4.64.0803261817110.1115@schroedinger.engr.sgi.com>
 <1206624052.8514.570.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Mar 2008, Peter Zijlstra wrote:

> confusion between semaphores and rwsems

rwsem is not a semaphore despite its name? What do you want to call it 
then?

