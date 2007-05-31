Return-Path: <linux-kernel-owner+w=401wt.eu-S1754381AbXEaUmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbXEaUmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 16:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbXEaUmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 16:42:08 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57366 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751953AbXEaUmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 16:42:07 -0400
Date: Thu, 31 May 2007 13:42:04 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Prarit Bhargava <prarit@redhat.com>
cc: "Luck, Tony" <tony.luck@intel.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       David Chinner <dgc@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: BUG: sleeping function called from invalid context at
 kernel/fork.c:385
In-Reply-To: <465EE7BB.4050605@redhat.com>
Message-ID: <Pine.LNX.4.64.0705311341360.6751@schroedinger.engr.sgi.com>
References: <617E1C2C70743745A92448908E030B2A01929DD3@scsmsx411.amr.corp.intel.com>
 <Pine.LNX.4.64.0705302019040.5583@schroedinger.engr.sgi.com>
 <465EE7BB.4050605@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2007, Prarit Bhargava wrote:

> Christoph, this is one less beer I owe you :) :) :)

Finally the compile works. Thanks.
