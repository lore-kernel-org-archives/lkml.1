Return-Path: <linux-kernel-owner+w=401wt.eu-S1757807AbYFVVOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757807AbYFVVOc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 17:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755991AbYFVVOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 17:14:04 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:11436 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690AbYFVVOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 17:14:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=M1ui+aZOzKRwn9/l+LkzO2CGvQ9raxG7viNjIKrR1oR7W7YziRb+MidIz0qmquy7Py
         uo31XBkim8SR95F8KhF+8wjoo+beqGcAOkAfjm7eHtgmupvt23cmsXlqXo2kPe7Np3nO
         GNp+yZqXNCgI8U/Bs7JOZk1UPXUSniENXQPDU=
Message-ID: <dd18b0c30806221414k1a865791raa8bfc2e3e9454ea@mail.gmail.com>
Date: Sun, 22 Jun 2008 21:14:00 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #10954] hda_intel: azx_get_response timeout, switching to polling mode: last cmd=0x011f000c
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <4mRZUF-hVeG.A.EDE.btpXIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <RzbtSgMztjP.A.jRD._spXIB@albercik>
	 <4mRZUF-hVeG.A.EDE.btpXIB@albercik>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2008 at 5:54 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10954
> Subject         : hda_intel: azx_get_response timeout, switching to polling mode: last cmd=0x011f000c
> Submitter       : Justin Mattock <justinmattock@gmail.com>
> Date            : 2008-06-21 2:05 (2 days old)
> References      : http://marc.info/?l=linux-kernel&m=121401399622190&w=4
>
>
>

I'm up in the air with this one, i.g. one minute this message is
appearing, and then the next it's not.
If nobody else is catching this or seeing this happen, then I'll take
it as a .config problem on my part.
regards;

-- 
Justin P. Mattock
