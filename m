Return-Path: <linux-kernel-owner+w=401wt.eu-S1756920AbXI2AMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbXI2AMh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 20:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755024AbXI2AMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 20:12:30 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:14081 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbXI2AM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 20:12:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=RpLQE0UJf3lfklYxrPh+o0CSyuD6JkE3q6pqooViEoaXrBrtAAjUlMGU7tVm0/0gN/faDFQavO6RGasR16r09X+WaczbfSB3b4XO+vCUQJGh7oioK8b4oVUEax7fgc1EWlN0MXq+w/5OlSJ4h+aD17H2Aszrj/9IUT52gq/YbS0=
Subject: Re: [PATCH/RFC] video gfx: merge kconfig menus
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, airlied@linux.ie,
       akpm <akpm@linux-foundation.org>
In-Reply-To: <20070924232536.b1123359.randy.dunlap@oracle.com>
References: <20070924232536.b1123359.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Sat, 29 Sep 2007 08:12:11 +0800
Message-Id: <1191024731.5273.6.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-24 at 23:25 -0700, Randy Dunlap wrote:
> Is there some reason that we don't put all video gfx config in one
> place?  Is the split just historical, based on subdirectory locations,
> or is there a bigger reason for it?

Just historical, based on subdirectory locations. Someone did attempt to
move the drm subdirectory under the video subdirectory during the 2.5
era but it was rejected.

Anyway, I'm fine with this too.

Tony


