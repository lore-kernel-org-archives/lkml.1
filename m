Return-Path: <linux-kernel-owner+w=401wt.eu-S1753459AbYAVTjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbYAVTjK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 14:39:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbYAVTio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 14:38:44 -0500
Received: from matrixpower.ru ([195.178.208.66]:34826 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbYAVTim convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 14:38:42 -0500
Cc: netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [0/4] DST: Distributed storage: Succumbed to live ant.
In-Reply-To: <20080122001122.GA21861@2ka.mipt.ru>
X-Mailer: Patch sending script by Greg Kroah-Hartman
Date: Tue, 22 Jan 2008 22:38:26 +0300
Message-Id: <1201030706738@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: lkml <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7BIT
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Distributed storage: Succumbed to live ant.

I'm pleased to announce the 14'th release of the distributed
storage subsystem (DST).

DST allows to form a storage on top of local and remote nodes
and combine them into linear or mirroring setup, which in
turn can be exported to remote nodes.

This is a maintenance release only.

Short changelog:
 * do not allocate big enough address structure on stack during
	local export node initialization
	Thanks to Serge Leschinsky and Konstantin Kalin for testing.

Overall list of features of the DST can be found on project's homepage:

http://tservice.net.ru/~s0mbre/old/?section=projects&item=dst

DST is also exported as a git tree available for clone and pull from
http://tservice.net.ru/~s0mbre/archive/dst/dst.git

Thank you.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>


