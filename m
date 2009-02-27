Return-Path: <linux-kernel-owner+w=401wt.eu-S1760822AbZB0WCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760822AbZB0WCS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 17:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756253AbZB0WCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 17:02:05 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55685 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755049AbZB0WCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 17:02:03 -0500
Message-ID: <49A862CD.2000409@redhat.com>
Date: Fri, 27 Feb 2009 14:01:49 -0800
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: filesystem time stamp resolution
References: <49A7232C.6050808@redhat.com> <87r61k2rl4.fsf@basil.nowhere.org>
In-Reply-To: <87r61k2rl4.fsf@basil.nowhere.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andi Kleen wrote:
> One issue is network file systems. The kernel has no idea what a
> remote NFS (or other network) file system will support, because it
> depends on the file system on the remote server.

Hence my point in the initial mail saying this would be nice to have a
solution for.

Possibly some of the people working on the next NFS protocol revision
(or similar protocols) read this and add appropriate requests to the
protocol.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmoYs0ACgkQ2ijCOnn/RHRJNwCdH27Jyr5Aaf/iSXo3WD0ZZy62
T4gAn0ktzaf1X1+51RrhS4HrhRvgZk+t
=EWlQ
-----END PGP SIGNATURE-----
