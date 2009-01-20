Return-Path: <linux-kernel-owner+w=401wt.eu-S1759988AbZATJ3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759988AbZATJ3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 04:29:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755154AbZATJ3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 04:29:11 -0500
Received: from bavaria.utcluj.ro ([193.226.5.35]:61339 "EHLO bavaria.utcluj.ro"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753726AbZATJ3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 04:29:10 -0500
X-Greylist: delayed 1871 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Jan 2009 04:29:10 EST
Subject: Re: LVM and root.
From: Cristi Magherusan <Cristi.Magherusan@net.utcluj.ro>
To: Prateek Donni <prateek.donni@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <a80c86b70901181218v4fbb9ad8ndc3a421c2772654b@mail.gmail.com>
References: <a80c86b70901181218v4fbb9ad8ndc3a421c2772654b@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Jan 2009 10:57:47 +0200
Message-Id: <1232441867.26012.20.camel@hyperion>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-19 at 01:48 +0530, Prateek Donni wrote:
> Changing size of root partition in LVM . Is it possible .. ?
The LVM volume could be resized, but for resizing the partition you may
need to use a live CD, since IIRC you cannot resize a mounted
filesystem.

-- 
Ing. Cristi Măgherușan, System/Network Engineer
Technical University of Cluj-Napoca, Romania
http://cc.utcluj.ro  +40264 401247

