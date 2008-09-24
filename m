Return-Path: <linux-kernel-owner+w=401wt.eu-S1755320AbYIXQtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbYIXQtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 12:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbYIXQs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 12:48:56 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:25923 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbYIXQsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 12:48:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=user-agent:date:from:to:cc:subject:message-id;
        b=ElxIgGnnnjEu+2eGbP0nX5AXXbbPG/teRzwD9r7dZQWK9DU1ZJtvtLeRP0JobPLvWt
         5yrWG8zKyPcDqv7sfmHc8PH7zReidjbg8v1hopWVhpQtRDhb1Z9X2+pxUn8jxgOB4cNE
         pKICA4YifT4rbiRiFQZVF5t5WgQqXY+JMFU3U=
User-Agent: quilt/0.46-1
Date: Wed, 24 Sep 2008 20:46:18 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, macro@linux-mips.org, yhlu.kernel@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [patch 0/3] [x86 -tip/master] apic cleanup
Message-ID: <48da6f73.0405560a.6f2f.ffffa11c@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello there,

this series does contain a few apic,ioapic cleanup patches.
Please review. Any comments are _quite_ appreciated!

They are quite trivial so should not take too much time
to review :)

		- Cyrill -
-- 
