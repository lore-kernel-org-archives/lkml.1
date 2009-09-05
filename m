Return-Path: <linux-kernel-owner+w=401wt.eu-S934565AbZIEClb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934565AbZIEClb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 22:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757090AbZIECl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 22:41:29 -0400
Received: from fifo99.com ([67.223.236.141]:44978 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756671AbZIECl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 22:41:28 -0400
Subject: Re: [PATCHv2 0/3] tracing - adding common method for
 reading/parsing user input
From: Daniel Walker <dwalker@fifo99.com>
To: jolsa@redhat.com
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org
In-Reply-To: <1252113181-3325-1-git-send-email-jolsa@redhat.com>
References: <1252113181-3325-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain
Date: Fri, 04 Sep 2009 19:41:26 -0700
Message-Id: <1252118486.6877.3.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-05 at 03:12 +0200, jolsa@redhat.com wrote:
> As 3 different places for 4 user input files were using the same way
> of reading and parsing user's input, I made one common routine to be
> used. 
> 

Patches 1 and 3 have a couple of minor checkpatch errors.. 

Daniel

