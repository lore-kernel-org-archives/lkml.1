Return-Path: <linux-kernel-owner+w=401wt.eu-S1757284AbZJ1E5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284AbZJ1E5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 00:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968AbZJ1E5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 00:57:44 -0400
Received: from mail-pw0-f42.google.com ([209.85.160.42]:43741 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbZJ1E5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 00:57:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:x-operating-system:user-agent;
        b=oNiC++ex815457+q/2gttRV8/tbJuG43FXh1EgAQxs5LnL4p0wNaH6OecUq2v0Kde4
         qSAGpSZMj96gnziDXLLwYSNQIIWd8NxSJF1bEUKnRhlqiUE7uYGW7ZhkiufgCUwEoz7b
         HneKeT+iRsfd4fuyeWRyAfG0PVVECjb21hJIQ=
Date: Wed, 28 Oct 2009 12:57:35 +0800
From: Li Hong <lihong.hi@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/8] tracing: recordmcount.pl Bug fixes and code
	improvement
Message-ID: <20091028045532.GA30036@uhli>
Mail-Followup-To: Steven Rostedt <rostedt@goodmis.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux uhli 2.6.28-11-generic 
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

This a following version for last patch series on recordmcount.pl. I have made
several changes according to your suggestions. Hopefully, they are ready to be
applied into your tree.

Changes include:

  - Improved the documentation amendment patch.
  - Keep the C like notation for error paths.
  - Drop the 'exit early' patch. Yes, it's not much useful, and actually, as
  you told me, there was a bug in it :)
  - minor typos and cleanups.

Thanks very much for your elaborate review and feedback.

-Li Hong
