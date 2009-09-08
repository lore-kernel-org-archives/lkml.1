Return-Path: <linux-kernel-owner+w=401wt.eu-S1752870AbZIHXKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbZIHXKI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 19:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbZIHXKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 19:10:07 -0400
Received: from fifo99.com ([67.223.236.141]:42379 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766AbZIHXKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 19:10:06 -0400
Subject: Re: [PATCH 00/20] ceph distributed file system client
From: Daniel Walker <dwalker@fifo99.com>
To: Sage Weil <sage@newdream.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1252450601-17610-1-git-send-email-sage@newdream.net>
References: <1252450601-17610-1-git-send-email-sage@newdream.net>
Content-Type: text/plain
Date: Tue, 08 Sep 2009 16:10:27 -0700
Message-Id: <1252451427.14793.38.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-08 at 15:56 -0700, Sage Weil wrote:
> We would like to see this merged soon.  What is the next step here?

Several of your patches have checkpatch errors or warnings ..  Usually
it's good to clean those up prior to merging .. Could you run these
through checkpatch and take care of any issues that it brings up.

Daniel

