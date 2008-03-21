Return-Path: <linux-kernel-owner+w=401wt.eu-S1759377AbYCUQZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759377AbYCUQZV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 12:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755673AbYCUQZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 12:25:04 -0400
Received: from el-out-1112.google.com ([209.85.162.181]:21495 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754901AbYCUQZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 12:25:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=rUrKvJmANJwHzMOkHZXmSJ0N6NEaD1vT9NH5uAwghglUzF2OqX3DdFGnwBVejUrsQTDBN4Gzy3BWrQ+3j/0OZ+1rRc4+oWcz73x46k3x9kxJZvkF2Zralqj8QjGsC5EzuCwDMOuoJBNKXHSti94NqNzqIAIb1ga5wFgHQjKgwpY=
Message-ID: <dd18b0c30803210925x755f3f07o1e2bb0cd60c9ce7e@mail.gmail.com>
Date: Fri, 21 Mar 2008 16:25:00 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: fglrx
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello; fair enough, I did ask ati about what I should do, but there
wasn't much help. Overall its not pretty, but If you are impatient for
ati to come out with an update then this should get you going(for 3D).
The problem I see is, SELinux is going out of whack due to fglrx
wanting a cap_t effective vector.  So on the secure side I probably
wont use fglrx until there is support for the proper capability.
or take you're approach and look at the open ati driver.


-- 
Justin P. Mattock
