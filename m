Return-Path: <linux-kernel-owner+w=401wt.eu-S1755415AbZCaKip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbZCaKip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 06:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754582AbZCaKib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 06:38:31 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:53277 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412AbZCaKia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 06:38:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=GV/Dn24sjct4L33Ix4+vb2FybNAL1YQrJzj9b2tXnHgiLcyQKL3TsiQ5M5MnN5q0K8
         h8mtOGHInR1uMjsS9DhbO2S1JxGRaHQB/UVeszGKCtcfb4rON8Ne6L7nF5VaSH1iI6PW
         6TV0iMiH+Od1vSLV320TE4/fPTofdvhf5vRB8=
MIME-Version: 1.0
Date: Tue, 31 Mar 2009 19:38:28 +0900
Message-ID: <28c262360903310338k20b8eebbncb86baac9b09e54@mail.gmail.com>
Subject: add_to_swap_cache with GFP_ATOMIC ?
From: Minchan Kim <minchan.kim@gmail.com>
To: Hugh Dickens <hugh@veritas.com>
Cc: linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all.

Let me have a question.

I don't know why we should call add_to_swap_cache with GFP_ATOMIC ?
Is there a special something for avoiding blocking?

-- 
Kinds regards,
Minchan Kim
