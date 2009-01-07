Return-Path: <linux-kernel-owner+w=401wt.eu-S1754541AbZAGMzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbZAGMzL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 07:55:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbZAGMy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 07:54:58 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:34310 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbZAGMy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 07:54:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=mKlUMw45znSfs6judjgZXDHV7Ze92+FRFuXw3bDibQYhtrhma9lgsP7+l45+hntuAV
         Rj11hlBPMNjYwoWHe+8OMb1N5Dtfz5fzAekZJv0R/c3x1ptW//RDOYx+YqSpi5IrtMhx
         v01iVBm50ij3gVXszq9SWuqyGHLdb9uWi8vqw=
Message-ID: <3f9a31f40901070454x678f75d2xee2a6de04a940321@mail.gmail.com>
Date: Wed, 7 Jan 2009 18:24:55 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: apw@canonical.com, davej@redhat.com, "Ingo Molnar" <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: scripts/checkpatch.pl : undefined value as an ARRAY reference
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andy,

On -tip git I am getting this error:

$ ./scripts/checkpatch.pl 000*
Can't use an undefined value as an ARRAY reference at
./scripts/checkpatch.pl line 451.

But earlier it was working great. Is this a feature or a bug.

Thanks,
--
JSR
