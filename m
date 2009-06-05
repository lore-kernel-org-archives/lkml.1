Return-Path: <linux-kernel-owner+w=401wt.eu-S1755650AbZFEW63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650AbZFEW63 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 18:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbZFEW6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 18:58:20 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:37805 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946AbZFEW6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 18:58:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=ABsheGuHRC1H8+WrQqz+MkPl5RUvAiP59OEJeY7qJvO5gPsXP8+UzYYF6AdXQLDNW/
         c6jGREYmlFVMBlQuQ69M7nklYOc30JdTJ7SMXs1Iflo7+2EHQHksxop7TkDjBv9KIXwk
         8ZPAnUmoYsMY3QVwbmNoUnU3QkLJIdOcGgScQ=
MIME-Version: 1.0
In-Reply-To: <6f5aac130906041048kc72d864y84ccd9f07737862b@mail.gmail.com>
References: <6f5aac130906041048kc72d864y84ccd9f07737862b@mail.gmail.com>
Date: Fri, 5 Jun 2009 15:58:20 -0700
Message-ID: <6f5aac130906051558i4852c861q96eff9432738df69@mail.gmail.com>
Subject: Fwd: Segmentation Fault with Linux Kernel 2.6.29
From: saurabh chokshi <sdchokshi@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Recently I have upgrade my Linux machine from kernel 2.6.26 to
2.6.29.4. After successful upgrade, I am getting couple issues with
kernel 2.6.29.

1. Whenever I use yum application, it gives segmentation fault. For
Example, "yum --help".

2. I use passwd command, it gives the  segmentation fault after t.

[saurabh@CentOS ~]$ passwd
Changing password for user saurabh.
Segmentation fault

3. After booting, whenever I am trying to login through terminal,  the
system ask for login id. After entering login id, it again prompts to
login id instead of password.

As of now, I found these many issues. It could be more than that.

All the above issues are not exist with linux kernel 2.6.26.

Could anyone help me out to resolve these issues?

Best Regards,
---------------------------------------
Saurabh D Chokshi
Master of Science - Computer Science
University of Southern California,
Los Angeles, CA
