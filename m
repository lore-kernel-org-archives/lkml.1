Return-Path: <linux-kernel-owner+w=401wt.eu-S1760317AbZE0V0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760317AbZE0V0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 17:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755025AbZE0V0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 17:26:14 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:60551 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754809AbZE0V0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 17:26:13 -0400
Subject: Re: [PATCH v2] integrity: nfsd imbalance bug fix
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, hooanon05@yahoo.co.jp,
       "J. Bruce Fields" <bfields@fieldses.org>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>, linux-nfs@vger.kernel.org,
       Mimi Zohar <zohar@us.ibm.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
In-Reply-To: <20090527140915.26efc70b.akpm@linux-foundation.org>
References: <1243431112-7388-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <20090527140915.26efc70b.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 27 May 2009 17:26:13 -0400
Message-Id: <1243459573.3408.9.camel@dyn9002018117.watson.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-27 at 14:09 -0700, Andrew Morton wrote:

> I have a note here that Hugh had some significant issues with the
> previous version of this patch.
> 
> Were these problems addressed?  If so, how?
> 
> Thanks.

With some reservation, he acked "[PATCH 2/3] integrity: move
ima_counts_get", but I'm not aware of his having any problems with this
patch. 

This patch was updated based on a comment from J.Bruce Fields.

Mimi Zohar

