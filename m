Return-Path: <linux-kernel-owner+w=401wt.eu-S1752995AbZI3M15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995AbZI3M15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 08:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbZI3M15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 08:27:57 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:35355 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577AbZI3M14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 08:27:56 -0400
Subject: Re: [PATCH] ima: ecryptfs fix imbalance message
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
       Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
       Dustin Kirkland <kirkland@canonical.com>,
       David Safford <safford@watson.ibm.com>, stable@kernel.org,
       Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <alpine.LRH.2.00.0909300947572.20949@tundra.namei.org>
References: <1254258535-18894-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <alpine.LRH.2.00.0909300947572.20949@tundra.namei.org>
Content-Type: text/plain
Date: Wed, 30 Sep 2009 08:27:55 -0400
Message-Id: <1254313675.3868.5.camel@dyn9002018117.watson.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-30 at 09:48 +1000, James Morris wrote:
> On Tue, 29 Sep 2009, Mimi Zohar wrote:
> 
> > The underlying files are measured. Update the counters to get rid of
> > the ecryptfs imbalance message. (http://bugzilla.redhat.com/519737)
> 
> Which kernel(s) is this needed for?

The patch applies cleanly to 2.6.31 stable and on.

Mimi

