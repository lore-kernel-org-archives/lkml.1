Return-Path: <linux-kernel-owner+w=401wt.eu-S1752756AbXJWCxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbXJWCxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 22:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbXJWCxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 22:53:05 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:38793 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbXJWCxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 22:53:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=UoSOIeKEoImuzE7fg6hmau5iRe7BFuqHOjqVAbHQe8SOKvTUP+yNRGwbFttH0tPBZrVgS6F704PqGdxEkwHtLVDCRCx6DD6p/ZpV4ckgxocCV9gRJYvVkM9mTanCpt4hJLwQwKUQIpdMcpggaAjb5bOoo3HXl3fn1xxeglDs/DM=
Message-ID: <b6a2187b0710221953h465369ach70ad60a469b5aac7@mail.gmail.com>
Date: Tue, 23 Oct 2007 10:53:02 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: CONFIG_ACPI_PROCFS depreciated? new acpid?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Noticed that CONFIG_ACPI_PROCFS and CONFIG_ACPI_PROC_EVENT are
indicated as depreciated. Does that imply a new acpid is needed to
access /sys instead?

Thanks,
Jeff.
