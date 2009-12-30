Return-Path: <linux-kernel-owner+w=401wt.eu-S1753146AbZL3SB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146AbZL3SB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 13:01:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbZL3SB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 13:01:27 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:52627 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbZL3SB0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 13:01:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=M26I+m8/5Kxj52dIWow1e7PdTXvPJbSn7gcuDyFwsVzoF2iLlMWuYf8QswIyYyvJx7
         WIfFfNq8UW4glSRH6CmtHrXZ/kGi+b+E3DNnHjeBjTXCJmt1ZAuKSa4RZWL+DoutLziI
         I0tVjAnzd9xTRhkn0PULLKnA5a5lMyPMrj/kI=
From: Miguel =?utf-8?q?Bot=C3=B3n?= <mboton@gmail.com>
To: Thomas Backlund <tmb@mandriva.org>
Subject: Re: BFS v0.313 CPU scheduler for 2.6.32
Date: Wed, 30 Dec 2009 19:00:29 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rc8-zen1; KDE/4.3.4; x86_64; ; )
Cc: Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200912301900.29578.mboton@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 30, 2009 at 2:55 PM, Thomas Backlund <tmb@mandriva.org> wrote:
> Nice.
> 
> any timeline for a version for 2.6.33 series kernels ?

If you want to try BFS on a 2.6.33 kernel, you can try this 'unofficial' port:
http://git.zen-kernel.org/?p=kernel/zen.git;a=shortlog;h=refs/heads/sched-bfs

I'm currently using it with no issues so far.

Greetings,

-- 
Miguel Botón
