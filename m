Return-Path: <linux-kernel-owner+w=401wt.eu-S1753570AbZIHD4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbZIHD4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 23:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753443AbZIHD4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 23:56:54 -0400
Received: from mail-qy0-f181.google.com ([209.85.221.181]:45042 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbZIHD4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 23:56:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=stV4N8p2LNecsUhfCpN+rEt0AxfUF6f3mkp1bV16ZaLqL+GhIzYK5W070zKCdRsXCh
         o7SH/5zvAjkl30Dndc/raUIZli720aIHyLslqW95n5vxqY9dBQ45Vf8pTidVPhcUt6xU
         0IgvWYGoJHnGy5UsGTa9U2VCqWCQK+q5NJJNM=
Date: Mon, 7 Sep 2009 23:56:48 -0400 (EDT)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@parag-desktop
To: albcamus@gmail.com
cc: linux-kernel@vger.kernel.org
Subject: Re: BUG UNIX: Poison overwritten with 2.6.31-rc6-00223-g6c30c53
Message-ID: <alpine.DEB.2.00.0909072323350.3940@parag-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, Aug 27, 2009 at 4:45 PM, Jike Song<albcamus@gmail.com> wrote:
>> hi, I hit this with vnc. Below is part of dmesg :

> Still producible in 2.6.31-rc9, anybody helps?

How does one go about reproducing this? You said VNC triggers this but 
what VNC version, server or client? What distro and what needs to be done 
with VNC to trigger this problem? I ask since I use VNC myself and test -git kernels 
and have not encountered this issue.

Parag

