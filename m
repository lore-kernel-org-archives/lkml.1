Return-Path: <linux-kernel-owner+w=401wt.eu-S1757259AbZGESbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259AbZGESbR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 14:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522AbZGESbC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 14:31:02 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:32962 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494AbZGESbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 14:31:01 -0400
Date: Sun, 5 Jul 2009 14:31:02 -0400 (EDT)
From: Jeff Arnold <jbarnold@ksplice.com>
X-X-Sender: jbarnold@vinegar-pot.mit.edu
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: linux-kernel@vger.kernel.org, tabbott@ksplice.com, wdaher@ksplice.com,
       andersk@ksplice.com, nelhage@ksplice.com, price@ksplice.com,
       geofft@ksplice.com
Subject: Re: Ksplice updates for Ubuntu 9.04 Jaunty
In-Reply-To: <20090703084359.08E3.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0907022047000.26615@vinegar-pot.mit.edu>
References: <alpine.DEB.1.10.0906250451210.22588@vinegar-pot.mit.edu> <20090703084359.08E3.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Jul 2009, KOSAKI Motohiro wrote:

> Afaik, Solaris and some other Unix like OS have similar rebootless
> security update mechanism.

No system other than Ksplice makes it practical to convert kernel patches 
into hot updates while writing little to no new code.

People have manually been making limited changes to running binaries for 
years, but making it practical to go from kernel patches to hot updates is 
new.

- Jeff
