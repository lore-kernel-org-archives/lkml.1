Return-Path: <linux-kernel-owner+w=401wt.eu-S1760964AbYLKTv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760964AbYLKTv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:51:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760263AbYLKTqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:46:44 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:54198 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760195AbYLKTqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:46:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=gQPCyjHdKjaWCsJcgyJh7wc4kEd4kBoNGjxAr+j+dVoFEV2u3dvsNxG5SIiyGqs0rb
         3lyZi4qCM24TTJDc3vK1xCnKR/ulyVlx+kFlbq8VgGsQbiPyWo7LxGg6KSAsxzH1jXXM
         QwXzM305c2pMghq0J+8kAZxPMpty6leD4ysy4=
Message-ID: <43e72e890812111146n1b9b0d07y99cd8cea3d72e952@mail.gmail.com>
Date: Thu, 11 Dec 2008 11:46:41 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Latest staging stuff
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

Where do I get stuff to send patches against your latest staging? I
thought it would be your staging git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git

But this doesn't seem to have the latest. I actually see more later stuff on:

http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/staging/

What is the difference between what you maintain in these? I take it
there is no actual git tree that is not just a directory with patches
for staging huh? It seems I would have to apply all the patches in
gregkh/gregkh-2.6/patches/staging/ and then send stuff against it.

  Luis
