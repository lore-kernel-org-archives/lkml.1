Return-Path: <linux-kernel-owner+w=401wt.eu-S1752853AbZHLXFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbZHLXFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 19:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbZHLXFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 19:05:48 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:59450 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752816AbZHLXFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 19:05:47 -0400
Date: Wed, 12 Aug 2009 19:05:43 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: David Wuertele <dave+gmane@wuertele.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Can initramfs be mounted read-only?
In-Reply-To: <loom.20090812T220624-312@post.gmane.org>
Message-ID: <alpine.DEB.1.10.0908121902400.32025@gentwo.org>
References: <loom.20090812T194647-427@post.gmane.org> <9b2b86520908121424qff7443fn84d07fb8dff7c863@mail.gmail.com> <loom.20090812T220624-312@post.gmane.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Try cramfs or romfs instead? Those are definitely readonly.


